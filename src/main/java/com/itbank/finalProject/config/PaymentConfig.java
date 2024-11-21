package com.itbank.finalProject.config;

import com.siot.IamportRestClient.IamportClient;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class PaymentConfig {

    @Bean
    public IamportClient iamportClient(){
        return new IamportClient("0580824623172206","ak6ggnGI77WVInfJE0oY1zhb4sOEiC9sE6arYF4qF2dFJ6nOtueZKwBjPRMEFUqUpomBVQTPkTlqdRTa");
    }
}
