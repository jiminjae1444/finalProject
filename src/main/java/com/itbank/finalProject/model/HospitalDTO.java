package com.itbank.finalProject.model;

import java.util.Objects;

public class HospitalDTO {
    private int id;
    private String hospital_id;
    private String hospital_name;
    private int sido_code;
    private String sido_name;
    private int gu_code;
    private String gu_name;
    private String address;
    private String Tel;
    private String homepage;
    private int doctors;
    private Double lng;
    private Double lat;
    private int medical_expenses;

    public int getMedical_expenses() {
        return medical_expenses;
    }

    public void setMedical_expenses(int medical_expenses) {
        this.medical_expenses = medical_expenses;
    }

    private String jinryo_name;

    public String getJinryo_name() {
        return jinryo_name;
    }

    public void setJinryo_name(String jinryo_name) {
        this.jinryo_name = jinryo_name;
    }

    private String ImageUrl;

    public String getImageUrl() {
        return ImageUrl;
    }

    public void setImageUrl(String imageUrl) {
        ImageUrl = imageUrl;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getHospital_id() {
        return hospital_id;
    }

    public void setHospital_id(String hospital_id) {
        this.hospital_id = hospital_id;
    }

    public String getHospital_name() {
        return hospital_name;
    }

    public void setHospital_name(String hospital_name) {
        this.hospital_name = hospital_name;
    }

    public int getSido_code() {
        return sido_code;
    }

    public void setSido_code(int sido_code) {
        this.sido_code = sido_code;
    }

    public String getSido_name() {
        return sido_name;
    }

    public void setSido_name(String sido_name) {
        this.sido_name = sido_name;
    }

    public int getGu_code() {
        return gu_code;
    }

    public void setGu_code(int gu_code) {
        this.gu_code = gu_code;
    }

    public String getGu_name() {
        return gu_name;
    }

    public void setGu_name(String gu_name) {
        this.gu_name = gu_name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getTel() {
        return Tel;
    }

    public void setTel(String tel) {
        Tel = tel;
    }

    public String getHomepage() {
        return homepage;
    }

    public void setHomepage(String homepage) {
        this.homepage = homepage;
    }

    public int getDoctors() {
        return doctors;
    }

    public void setDoctors(int doctors) {
        this.doctors = doctors;
    }

    public Double getLng() {
        return lng;
    }

    public void setLng(Double lng) {
        this.lng = lng;
    }

    public Double getLat() {
        return lat;
    }

    public void setLat(Double lat) {
        this.lat = lat;
    }


    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        HospitalDTO that = (HospitalDTO) o;
        return Objects.equals(hospital_id, that.hospital_id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(hospital_id);
    }
}
