package com.memorres.fitnesskit.manager;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.memorres.fitnesskit.permission.Request;
import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;
import com.google.android.gms.fitness.Fitness;
import com.google.android.gms.fitness.FitnessOptions;
import com.google.android.gms.fitness.data.Bucket;
import com.google.android.gms.fitness.data.DataPoint;
import com.google.android.gms.fitness.data.DataSet;
import com.google.android.gms.fitness.data.DataSource;
import com.google.android.gms.fitness.data.DataType;
import com.google.android.gms.fitness.data.Field;
import com.google.android.gms.fitness.request.DataReadRequest;
import com.google.android.gms.fitness.result.DataReadResponse;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.concurrent.TimeUnit;
import static com.memorres.fitnesskit.permission.Permission.ACTIVITY;
import static com.memorres.fitnesskit.permission.Permission.CALORIES;
import static com.memorres.fitnesskit.permission.Permission.DISTANCE;
import static com.memorres.fitnesskit.permission.Permission.HEART_RATE;
import static com.memorres.fitnesskit.permission.Permission.STEP;

public class Manager implements ActivityEventListener {

    private final static int GOOGLE_PLAY_SERVICE_ERROR_DIALOG = 2404;
    private final static int GOOGLE_FIT_PERMISSIONS_REQUEST_CODE = 111;
    private static final int MY_PERMISSIONS_REQUEST_ACTIVITY_RECOGNITION = 101;
    private Promise promise;
    private final static DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", Locale.getDefault());

    private static boolean isGooglePlayServicesAvailable(final Activity activity) {
        GoogleApiAvailability googleApiAvailability = GoogleApiAvailability.getInstance();
        int status = googleApiAvailability.isGooglePlayServicesAvailable(activity);
        if (status != ConnectionResult.SUCCESS) {
            if (googleApiAvailability.isUserResolvableError(status)) {
                googleApiAvailability.getErrorDialog(activity, status, GOOGLE_PLAY_SERVICE_ERROR_DIALOG).show();
            }
            Log.d("GooglePlayServices", "Unavailable");
            return false;
        }
        ;
        Log.d("GooglePlayServices", "Available");
        Log.d("Permmission", String.valueOf(checkPermissions(activity)));

        return checkPermissions(activity);
    }

    private static boolean checkPermissions(final Activity activity) {
        if (ContextCompat.checkSelfPermission(activity, Manifest.permission.ACTIVITY_RECOGNITION)
                != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(activity,
                    new String[]{"Manifest.permission.ACTIVITY_RECOGNITION"},
                    MY_PERMISSIONS_REQUEST_ACTIVITY_RECOGNITION);
            return true;
        }
        else {
            return false;
        }
    }

    protected FitnessOptions.Builder addPermissionToFitnessOptions(final FitnessOptions.Builder fitnessOptions, final ArrayList<Request> permissions) {
        int length = permissions.size();
        for (int i = 0; i < length; i++) {
            Request currentRequest = permissions.get(i);
            switch (currentRequest.permission) {
                case STEP:
                    fitnessOptions
                            .addDataType(DataType.TYPE_STEP_COUNT_DELTA, currentRequest.permissionAccessType)
                            .addDataType(DataType.TYPE_STEP_COUNT_CUMULATIVE, currentRequest.permissionAccessType);
                    break;
                case DISTANCE:
                    fitnessOptions.addDataType(DataType.TYPE_DISTANCE_DELTA, currentRequest.permissionAccessType);
                    break;
                case CALORIES:
                    fitnessOptions.addDataType(DataType.TYPE_CALORIES_EXPENDED, currentRequest.permissionAccessType);
                    break;
                case ACTIVITY:
                    fitnessOptions.addDataType(DataType.TYPE_ACTIVITY_SEGMENT, currentRequest.permissionAccessType);
                    break;
                case HEART_RATE:
                    fitnessOptions.addDataType(DataType.TYPE_HEART_RATE_BPM, currentRequest.permissionAccessType);
                    break;
                default:
                    break;
            }
        }
        return fitnessOptions;
    }

    public boolean isAuthorized(final Activity activity, final ArrayList<com.memorres.fitnesskit.permission.Request> permissions) {
        if (isGooglePlayServicesAvailable(activity)) {
            FitnessOptions fitnessOptions = addPermissionToFitnessOptions(FitnessOptions.builder(), permissions)
                    .build();
            return GoogleSignIn.hasPermissions(GoogleSignIn.getLastSignedInAccount(activity), fitnessOptions);
        }
        return false;
    }




    public void requestPermissions(@NonNull Activity currentActivity, final ArrayList<Request> permissions, Promise promise) {
        try {
            this.promise = promise;
            FitnessOptions fitnessOptions = addPermissionToFitnessOptions(FitnessOptions.builder(), permissions)
                    .build();
            GoogleSignInAccount account = GoogleSignIn.getAccountForExtension(currentActivity, fitnessOptions);
            if (!GoogleSignIn.hasPermissions(account, fitnessOptions)) {
                GoogleSignIn.requestPermissions(
                        currentActivity,
                        GOOGLE_FIT_PERMISSIONS_REQUEST_CODE,
                        account,
                        fitnessOptions);
            }
        } catch (Exception e) {
            promise.reject(e);
        }
    }



    public void getSteps(Context context, long startDate, long endDate, String customInterval, final Promise promise){
        DataSource ESTIMATED_STEP_DELTAS = new DataSource.Builder()
                .setDataType(DataType.TYPE_STEP_COUNT_DELTA)
                .setType(DataSource.TYPE_DERIVED)
                .setStreamName("estimated_steps")
                .setAppPackageName("com.google.android.gms")
                .build();

        TimeUnit interval;
        if(customInterval == "hour"){
            interval = TimeUnit.HOURS;
        }else{
            interval = TimeUnit.DAYS;
        }

        DataReadRequest readRequest = new DataReadRequest.Builder()
                .aggregate(ESTIMATED_STEP_DELTAS,    DataType.AGGREGATE_STEP_COUNT_DELTA)
                .bucketByTime(1, interval)
                .setTimeRange( startDate, endDate, TimeUnit.MILLISECONDS)
                .build();

        Fitness.getHistoryClient(context, GoogleSignIn.getLastSignedInAccount(context))
                .readData(readRequest)
                .addOnSuccessListener(new OnSuccessListener<DataReadResponse>() {
                    @Override
                    public void onSuccess(DataReadResponse dataReadResponse) {
                        if (dataReadResponse.getBuckets().size() > 0) {
                            WritableArray steps = Arguments.createArray();
                            for (Bucket bucket : dataReadResponse.getBuckets()) {
                                List<DataSet> dataSets = bucket.getDataSets();
                                for (DataSet dataSet : dataSets) {
                                    processStep(dataSet, steps);
                                }
                            }
                            promise.resolve(steps);
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

    private void processStep(DataSet dataSet, WritableArray map) {

        WritableMap stepMap = Arguments.createMap();

        for (DataPoint dp : dataSet.getDataPoints()) {
            for(Field field : dp.getDataType().getFields()) {
                stepMap.putString("date", dateFormat.format(dp.getStartTime(TimeUnit.MILLISECONDS)));
                stepMap.putDouble("steps", dp.getValue(field).asInt());
                map.pushMap(stepMap);
            }
        }
    }


    @Override
    public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
        if (resultCode == Activity.RESULT_OK && requestCode == GOOGLE_FIT_PERMISSIONS_REQUEST_CODE) {
            promise.resolve(true);
        }
        if (resultCode == Activity.RESULT_CANCELED && requestCode == GOOGLE_FIT_PERMISSIONS_REQUEST_CODE) {
            promise.resolve(false);
        }
    }

    @Override
    public void onNewIntent(Intent intent) {

    }
}