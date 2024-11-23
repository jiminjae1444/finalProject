package com.itbank.finalProject;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.time.Duration;

import javax.servlet.http.HttpServletRequest;

import org.openqa.selenium.By;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.springframework.stereotype.Component;

import lombok.extern.log4j.Log4j;

@Component
@Log4j
public class NaverMapCrawler {

    private static final String NAVER_MAP_URL = "https://map.naver.com/v5/search/";

    public String getImageFromNaverMap(String guName, String hospitalName,HttpServletRequest request) throws UnsupportedEncodingException {
        WebDriver driver = new ChromeDriver();
        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(20));
        String imageUrl = null;

        try {
            // 검색 URL 생성 및 이동
            String searchQuery = URLEncoder.encode(guName + " " + hospitalName, "UTF-8");
            driver.get(NAVER_MAP_URL + searchQuery);

            try {
                // entryIframe 시도, 실패 시 searchIframe에서 병원 링크 클릭
                WebElement entryIframe = wait.until(ExpectedConditions.presenceOfElementLocated(By.cssSelector("iframe#entryIframe")));
                driver.switchTo().frame(entryIframe);
            } catch (TimeoutException e) {
                // entryIframe을 찾을 수 없는 경우, searchIframe으로 이동
                driver.switchTo().defaultContent();
                WebElement searchIframe = wait.until(ExpectedConditions.presenceOfElementLocated(By.cssSelector("iframe#searchIframe")));
                driver.switchTo().frame(searchIframe);

                // 병원 링크 클릭 시도
                WebElement hospitalLink = wait.until(ExpectedConditions.elementToBeClickable(By.cssSelector("ul > li a")));
                hospitalLink.click();

                // 다시 entryIframe으로 돌아가서 이미지 찾기
                driver.switchTo().defaultContent();
                WebElement entryIframeAfterClick = wait.until(ExpectedConditions.presenceOfElementLocated(By.cssSelector("iframe#entryIframe")));
                driver.switchTo().frame(entryIframeAfterClick);
            }

            // 이미지 요소를 찾고 URL 획득
            WebElement imageElement = wait.until(ExpectedConditions.presenceOfElementLocated(By.cssSelector("img")));
            imageUrl = imageElement.getAttribute("src");

        } catch (TimeoutException e) {
            log.error("요소를 찾지 못하거나 대기 시간이 초과되었습니다: " + e.getMessage());
            imageUrl = request.getContextPath() + "/resources/image/default_hospital.png";
        } finally {
            driver.quit();  // 드라이버 종료
        }

//        log.info("이미지 URL: " + imageUrl);
        return imageUrl;
    }
}