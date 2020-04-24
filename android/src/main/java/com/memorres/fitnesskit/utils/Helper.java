package com.memorres.fitnesskit.utils;

import android.util.Log;

import com.facebook.react.bridge.ReadableMap;
import com.memorres.fitnesskit.FitnesskitModule;
import com.memorres.fitnesskit.permission.Request;
import com.google.android.gms.fitness.FitnessOptions;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

import static com.memorres.fitnesskit.utils.MapUtil.toJSONObject;

public class Helper {

    private final static String TAG = FitnesskitModule.class.getName();

    public static ArrayList<Request> createRequest(ReadableMap permissions) {
        ArrayList<Request> requestArrayList = new ArrayList<>();
        JSONObject obj = null;
        try {
            obj = new JSONObject(String.valueOf(toJSONObject(permissions)));
            String permissionStr = obj.getString("permissions");
            JSONObject obj1 = new JSONObject(permissionStr);
            JSONArray writeArr = obj1.getJSONArray("write");
            JSONArray readArr = obj1.getJSONArray("read");
            requestArrayList = createRequestFromArrays(writeArr,readArr);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        Log.e("ArrayList", requestArrayList.toString());
        return requestArrayList;
    }

    private static ArrayList<Request> createRequestFromArrays(JSONArray writeArray, JSONArray readArray){

        ArrayList<Request> requestPermissions = new ArrayList<>();
        int writeArraySize = writeArray.length();
        for(int i = 0; i < writeArraySize; i++) {
            try {
                final int permission = getPermissionCode(writeArray.get(i).toString());
                final int permissionAccessType = FitnessOptions.ACCESS_WRITE;
                requestPermissions.add(new Request(permission, permissionAccessType));
            } catch (NullPointerException e) {
                Log.e(TAG, e.getMessage());
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        int readArraySize = readArray.length();
        for(int i = 0; i < readArraySize; i++) {
            try {
                final int permission = getPermissionCode(readArray.get(i).toString());
                final int permissionAccessType = FitnessOptions.ACCESS_READ;
                requestPermissions.add(new Request(permission, permissionAccessType));
            } catch (NullPointerException e) {
                Log.e(TAG, e.getMessage());
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        return requestPermissions;
    }

    private static int getPermissionCode(String str) {
        String permissionString = str.toUpperCase();
        switch (permissionString){
            case "STEP" :
                return 0;
            case "DISTANCE" :
                return 1;
            case "CALORIE" :
                return 2;
            case "ACTIVITY" :
                return 3;
            case "HEARTRATE" :
                return 4;
        }
        return 0;
    }
}
