package com.memorres.fitnesskit.manager;

import android.content.Context;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.fitness.Fitness;
import com.google.android.gms.fitness.data.Bucket;
import com.google.android.gms.fitness.data.DataPoint;
import com.google.android.gms.fitness.data.DataSet;
import com.google.android.gms.fitness.data.DataType;
import com.google.android.gms.fitness.data.Field;
import com.google.android.gms.fitness.request.DataReadRequest;
import com.google.android.gms.fitness.result.DataReadResponse;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import java.text.DateFormat;
import java.util.List;
import java.util.concurrent.TimeUnit;
import androidx.annotation.NonNull;



public class HeartRateManager {


    public void getHeartRate(Context context, long startDate, long endDate,final Promise promise) {
        DataReadRequest readRequest = new DataReadRequest.Builder()
                .aggregate(DataType.TYPE_HEART_POINTS, DataType.AGGREGATE_HEART_POINTS)
                .bucketByTime(1, TimeUnit.DAYS)
                .setTimeRange(startDate, endDate, TimeUnit.MILLISECONDS)
                .build();

        Fitness.getHistoryClient(context, GoogleSignIn.getLastSignedInAccount(context))
                .readData(readRequest)
                .addOnSuccessListener(new OnSuccessListener<DataReadResponse>() {
                    @Override
                    public void onSuccess(DataReadResponse dataReadResponse) {
                        if (dataReadResponse.getBuckets().size() > 0) {
                            WritableArray heartRates = Arguments.createArray();
                            for (Bucket bucket : dataReadResponse.getBuckets()) {
                                List<DataSet> dataSets = bucket.getDataSets();
                                for (DataSet dataSet : dataSets) {
                                    processHeartRate(dataSet, heartRates);
                                }
                            }
                            promise.resolve(heartRates);
                        }
                    }
                })
                .addOnFailureListener(new OnFailureListener() {
                    @Override
                    public void onFailure(@NonNull Exception e) {
                        promise.reject(e);
                    }
                })
                .addOnCompleteListener(new OnCompleteListener<DataReadResponse>() {
                    @Override
                    public void onComplete(@NonNull Task<DataReadResponse> task) {
                    }
                });
    }

    private void processHeartRate(DataSet dataSet, WritableArray map) {

        WritableMap heartRateMap = Arguments.createMap();
        DateFormat dateFormat = DateFormat.getDateInstance();
        String previousDate = "";
        for (DataPoint dp : dataSet.getDataPoints()) {
            for(Field field : dp.getDataType().getFields()) {
                if(!(previousDate.equals(dateFormat.format(dp.getStartTime(TimeUnit.MILLISECONDS)))))
                {
                    previousDate = dateFormat.format(dp.getStartTime(TimeUnit.MILLISECONDS));
                    heartRateMap.putString("date", dateFormat.format(dp.getStartTime(TimeUnit.MILLISECONDS)));
                    heartRateMap.putDouble("heartRate", dp.getValue(field).asFloat());
                    map.pushMap(heartRateMap);
                }
            }
        }
    }
}