package com.memorres.fitnesskit.manager;

import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.fitness.Fitness;
import com.google.android.gms.fitness.FitnessActivities;
import com.google.android.gms.fitness.data.Bucket;
import com.google.android.gms.fitness.data.DataPoint;
import com.google.android.gms.fitness.data.DataSet;
import com.google.android.gms.fitness.data.DataSource;
import com.google.android.gms.fitness.data.DataType;
import com.google.android.gms.fitness.data.Field;
import com.google.android.gms.fitness.data.Session;
import com.google.android.gms.fitness.request.DataReadRequest;
import com.google.android.gms.fitness.request.SessionReadRequest;
import com.google.android.gms.fitness.result.DataReadResponse;
import com.google.android.gms.fitness.result.SessionReadResponse;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;

import java.text.DateFormat;
import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.concurrent.TimeUnit;
import java.util.function.Predicate;
import java.util.stream.Collectors;

import static com.facebook.react.common.ReactConstants.TAG;

public class SleepManager {
    private final static DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", Locale.getDefault());

    public void getSleepData(Context context, double startDate, double endDate, final Promise promise) {
        long startVal = ((long)startDate)*1000;
        long endVal = ((long)endDate)*1000;

        SessionReadRequest request = new SessionReadRequest.Builder()
                .readSessionsFromAllApps()
                .includeSleepSessions()
                .read(DataType.TYPE_SLEEP_SEGMENT)
                .setTimeInterval(startVal,endVal, TimeUnit.MILLISECONDS)
                .build();



        Fitness.getSessionsClient(context, GoogleSignIn.getLastSignedInAccount(context))
                .readSession(request)
                .addOnSuccessListener(new OnSuccessListener<SessionReadResponse>() {
                    @Override
                    public void onSuccess(SessionReadResponse response) {
                        List<Session> sleepSessions = response.getSessions()
                                .stream()
                                .filter(s -> s.getActivity().equals(FitnessActivities.SLEEP))
                                .collect(Collectors.toList());

                        WritableArray sleepVal = Arguments.createArray();
                        for (Session session : sleepSessions) {
                            WritableMap sleepData = Arguments.createMap();

                            sleepData.putString("addedBy", session.getAppPackageName());
                            sleepData.putString("startDate", dateFormat.format(session.getStartTime(TimeUnit.MILLISECONDS)));
                            sleepData.putString("endDate", dateFormat.format(session.getEndTime(TimeUnit.MILLISECONDS)));

                            // If the sleep session has finer granularity sub-components, extract them:
                            List<DataSet> dataSets = response.getDataSet(session);
                            WritableArray granularity = Arguments.createArray();
                            for (DataSet dataSet : dataSets) {
                                processDataSet(dataSet, granularity);
                            }
                            sleepData.putArray("granularity", granularity);

                            sleepVal.pushMap(sleepData);
                        }
                        promise.resolve(sleepVal);
                    }




                })
                .addOnFailureListener(new OnFailureListener() {
                    @Override
                    public void onFailure(@NonNull Exception e) {
                        promise.reject(e);
                    }
                });
    }

    private void processDataSet(DataSet dataSet, WritableArray granularity) {
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", Locale.getDefault());

        for (DataPoint dp : dataSet.getDataPoints()) {
            WritableMap sleepStage = Arguments.createMap();

            sleepStage.putInt("sleepStage", dp.getValue(Field.FIELD_SLEEP_SEGMENT_TYPE).asInt());
            sleepStage.putString("startDate", dateFormat.format(dp.getStartTime(TimeUnit.MILLISECONDS)));
            sleepStage.putString("endDate", dateFormat.format(dp.getEndTime(TimeUnit.MILLISECONDS)));

            granularity.pushMap(sleepStage);
        }
    }
    
}