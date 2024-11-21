package com.itbank.finalProject.model;

//id                  integer        generated as identity primary key,
//member_id           integer        references member(id),
//memberLocation      varchar2(255)  not null

public class SubLocationDTO {
   
   private int id;
   private int member_id;
   private String memberLocation;
   
   private String userid;
   private String location;
   
   public int getId() {
      return id;
   }
   public void setId(int id) {
      this.id = id;
   }
   public int getMember_id() {
      return member_id;
   }
   public void setMember_id(int member_id) {
      this.member_id = member_id;
   }
   public String getMemberLocation() {
      return memberLocation;
   }
   public void setMemberLocation(String memberLocation) {
      this.memberLocation = memberLocation;
   }
   public String getUserid() {
      return userid;
   }
   public void setUserid(String userid) {
      this.userid = userid;
   }
   public String getLocation() {
      return location;
   }
   public void setLocation(String location) {
      this.location = location;
   }

}
