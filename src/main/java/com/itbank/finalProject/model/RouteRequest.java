package com.itbank.finalProject.model;

public class RouteRequest {
    private double startX;  // 출발지 위도
    private double startY;  // 출발지 경도
    private double endX;    // 도착지 위도
    private double endY;    // 도착지 경도

    // Getter와 Setter 추가

    public double getStartX() {
        return startX;
    }

    public void setStartX(double startX) {
        this.startX = startX;
    }

    public double getStartY() {
        return startY;
    }

    public void setStartY(double startY) {
        this.startY = startY;
    }

    public double getEndX() {
        return endX;
    }

    public void setEndX(double endX) {
        this.endX = endX;
    }

    public double getEndY() {
        return endY;
    }

    public void setEndY(double endY) {
        this.endY = endY;
    }
}