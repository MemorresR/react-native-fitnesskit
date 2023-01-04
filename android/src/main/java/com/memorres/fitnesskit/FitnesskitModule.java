package com.memorres.fitnesskit;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.auth.api.signin.GoogleSignInOptions;
import com.google.android.gms.tasks.OnCanceledListener;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.memorres.fitnesskit.manager.CalorieManager;
import com.memorres.fitnesskit.manager.DistanceManager;
import com.memorres.fitnesskit.manager.HeartRateManager;
import com.memorres.fitnesskit.manager.Manager;
import com.memorres.fitnesskit.manager.SleepManager;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import static com.memorres.fitnesskit.utils.Helper.createRequest;

public class FitnesskitModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;
    private final Manager manager;
    private final DistanceManager distanceManager;
    private final CalorieManager calorieManager;
    private final HeartRateManager hRateManager;
    private final SleepManager sleepManager;

    public FitnesskitModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.manager = new Manager();
        this.distanceManager = new DistanceManager();
        this.calorieManager = new CalorieManager();
        this.hRateManager = new HeartRateManager();
        this.sleepManager = new SleepManager();
        this.reactContext = reactContext;
        reactContext.addActivityEventListener(this.manager);

    }

    @Override
    public String getName() {
        return "Fitnesskit";
    }

    @ReactMethod
    public void isAuthorized(ReadableMap permissions, Promise promise){
        promise.resolve(manager.isAuthorized(getCurrentActivity(), createRequest(permissions)));
    }

    @ReactMethod
    public void requestPermissions(ReadableMap permissions, Promise promise){
        final Activity activity = getCurrentActivity();
        if(activity != null) {
            manager.requestPermissions(activity,createRequest(permissions), promise);
        }else{
            promise.reject(new Throwable());
        }
    }

    @ReactMethod
    public void disableFit(Promise promise){
        final Activity activity = getCurrentActivity();
        if(activity != null) {
            manager.logout(activity, promise);
        }else{
            promise.reject(new Throwable());
        }
    }

    @ReactMethod
    public void getStepCount(ReadableMap stepOption, Promise promise){
        if(stepOption.hasKey("startDate")) {
            String startDate = stepOption.getString("startDate");
            String endDate = stepOption.getString("endDate");
            long startseconds = 0, endseconds = 0;
            DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
            try {
                Date startTime = format.parse(startDate);
                Date endTime = format.parse(endDate);
                startseconds = startTime.getTime();
                endseconds = endTime.getTime();
            } catch (ParseException e) {
                e.printStackTrace();
            }
            String interval = "days";
            try {
                manager.getSteps(getCurrentActivity(), startseconds, endseconds, interval, promise);
            } catch (Error e) {
                promise.reject(e);
            }
        }else{
            promise.reject(reactContext.getResources().getString(R.string.date_not_correct));
        }
    }

    @ReactMethod
    public void getDistance(ReadableMap stepOption, Promise promise){
        if(stepOption.hasKey("startDate")) {
            String startDate = stepOption.getString("startDate");
            String endDate = stepOption.getString("endDate");
            long startseconds = 0, endseconds = 0;
            DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
            try {
                Date startTime = format.parse(startDate);
                Date endTime = format.parse(endDate);
                startseconds = startTime.getTime();
                endseconds = endTime.getTime();
            } catch (ParseException e) {
                e.printStackTrace();
            }
            String interval = "days";
            try {
                distanceManager.getDistance(getCurrentActivity(), startseconds, endseconds, interval, promise);
            } catch (Error e) {
                promise.reject(e);
            }
        }else{
            promise.reject(reactContext.getResources().getString(R.string.date_not_correct));
        }
    }

    @ReactMethod
    public void getEnergy(ReadableMap stepOption, Promise promise){
        if(stepOption.hasKey("startDate")) {
            String startDate = stepOption.getString("startDate");
            String endDate = stepOption.getString("endDate");
            long startseconds = 0, endseconds = 0;
            DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
            try {
                Date startTime = format.parse(startDate);
                Date endTime = format.parse(endDate);
                startseconds = startTime.getTime();
                endseconds = endTime.getTime();
            } catch (ParseException e) {
                e.printStackTrace();
            }
            String interval = "days";
            try {
                calorieManager.getCalorie(getCurrentActivity(), startseconds, endseconds, interval, promise);
            } catch (Error e) {
                promise.reject(e);
            }
        }else{
            promise.reject(reactContext.getResources().getString(R.string.date_not_correct));
        }
    }

    @ReactMethod
    public void getHeartRate(ReadableMap stepOption, Promise promise){
        if(stepOption.hasKey("startDate")) {
            String startDate = stepOption.getString("startDate");
            String endDate = stepOption.getString("endDate");
            long startseconds = 0, endseconds = 0;
            DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
            try {
                Date startTime = format.parse(startDate);
                Date endTime = format.parse(endDate);
                startseconds = startTime.getTime();
                endseconds = endTime.getTime();
            } catch (ParseException e) {
                e.printStackTrace();
            }
            try {
                hRateManager.getHeartRate(getCurrentActivity(), startseconds, endseconds, promise);
            } catch (Error e) {
                promise.reject(e);
            }
        }else{
            promise.reject(reactContext.getResources().getString(R.string.date_not_correct));
        }
    }

    @ReactMethod
    public void getSleepData(ReadableMap sleepOption, Promise promise){

        if (android.os.Build.VERSION.SDK_INT < android.os.Build.VERSION_CODES.N){
            promise.reject("Method not available");
            return;
        }
        if(sleepOption.hasKey("startDate")) {
            double startDate = sleepOption.getDouble("startDate");
            double endDate = sleepOption.getDouble("endDate");
            String interval = "days";
            try {
                sleepManager.getSleepData(getCurrentActivity(),  startDate,  endDate, promise);
            } catch (Error e) {
                promise.reject(e);
            }
        }else{
            promise.reject(reactContext.getResources().getString(R.string.date_not_correct));
        }
    }


}