package com.itbank.finalProject.repository;

import java.awt.Component;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.itbank.finalProject.model.BookingDTO;
import com.itbank.finalProject.model.HospitalTimeDTO;
import com.itbank.finalProject.model.NotificationDTO;

public interface BookingDAO {

	int bookingInsert(BookingDTO bookingDTO);

	BookingDTO selectBookingInfo(@Param("hospital_id") int hospital_id, @Param("member_id") int member_id);

	HospitalTimeDTO selectHospitalTime(int hospital_id);

	int bookingCancel(@Param("member_id")int member_id, @Param("hospital_id") int hospital_id);

	int notificationBookingCancel(BookingDTO dto);

	int bookingTimeOver(@Param("member_id")int member_id, @Param("hospital_id") int hospital_id);

	int notificationBookingTimeOver(BookingDTO dto);

	List<NotificationDTO> selectNotificationList(int selectStart);

	int notificationBooking(BookingDTO bookingDTO);

	int selectNotificationCount();

	int readNotification(@Param("selectStart")int selectStart, @Param("selectEnd")int selectEnd);

	int bookingUpdate(BookingDTO bookingDTO);

	int notificationBookingUpdate(BookingDTO dto);

	int selectNotificationAllCount();

	int notificationBookingOneDay(BookingDTO dto);

	int deleteNotification(int id);

	int deleteNotificationAll();

	int deleteMyFavorites(int id);

	int deleteMyfavoritesAll();

}