package com.memorres.fitnesskit.permission;

public class Request {
    public final int permission;
    public final int permissionAccessType;

    public Request(int permission, int permissionAccessType) {
        this.permission = permission;
        this.permissionAccessType = permissionAccessType;
    }
}