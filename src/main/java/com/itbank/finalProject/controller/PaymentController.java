package com.itbank.finalProject.controller;

import com.siot.IamportRestClient.IamportClient;
import com.siot.IamportRestClient.exception.IamportResponseException;
import com.siot.IamportRestClient.request.CancelData;
import com.siot.IamportRestClient.response.IamportResponse;
import com.siot.IamportRestClient.response.Payment;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequiredArgsConstructor
public class PaymentController {
    private final IamportClient iamportClient;

    @PostMapping(value = "cancelPayment" , produces = "application/json; charset=utf-8")
    public HashMap<String,Object> cancelPayment(@RequestBody Map<String, String> payment) {
        String merchantUid = payment.get("merchant_uid");
//        System.out.println(merchantUid);
        HashMap<String, Object> response = new HashMap<>();

        try {
            // CancelData 객체 생성: merchantUid와 취소 여부를 지정
            CancelData cancelData = new CancelData(merchantUid, false);

            // 결제 취소 요청
            IamportResponse<Payment> iamportResponse = iamportClient.cancelPaymentByImpUid(cancelData);

            // 취소가 성공한 경우
            if (iamportResponse.getResponse() != null) {
                response.put("success", true);
                response.put("message", "결제 취소 성공");
            } else {
                response.put("success", false);
                response.put("message", "결제 취소 실패");
            }
        } catch (IamportResponseException | IOException e) {
            response.put("success", false);
            response.put("error_msg", e.getMessage());
        }
        return response;
    }
}