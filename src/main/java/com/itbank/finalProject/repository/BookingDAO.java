package com.itbank.finalProject.repository;

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


	int notificationBooking(BookingDTO bookingDTO);

	int selectNotificationCount(int member_id);

	int readNotification(@Param("selectStart")int selectStart, @Param("selectEnd")int selectEnd, @Param("member_id")int member_id);

	int bookingUpdate(BookingDTO bookingDTO);

	int notificationBookingUpdate(BookingDTO dto);

	int selectNotificationAllCount(int member_id);


	int notificationBookingOneDay(BookingDTO dto);

	int deleteNotification(int id);

	int deleteNotificationAll(int member_id);

	int deleteMyFavorites(@Param("id")int id, @Param("member_id")int member_id);

	int deleteMyfavoritesAll(int member_id);

	List<NotificationDTO> selectNotificationList(@Param("selectStart")int selectStart, @Param("member_id") int member_id);
}