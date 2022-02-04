package com.sparta.finalweekapi.controller;

import com.sparta.finalweekapi.repositories.UserRepository;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class UserControllerTest {

    private static final String GET_AUTH = "http://localhost:8080/auth/test?token=eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJrb25yYWQyMjIwIn0.WZiR-67FY1299ipKhgLFTbwTy9J7NhyXcWEmdGPQbFY";
    private static final String GET_ITEM = "http://localhost:8080/items/all?token=eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJrb25yYWQyMjIwIn0.WZiR-67FY1299ipKhgLFTbwTy9J7NhyXcWEmdGPQbFY";
    private static final String POST_ITEM = "http://localhost:8080/items/add?token=eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJrb25yYWQyMjIwIn0.WZiR-67FY1299ipKhgLFTbwTy9J7NhyXcWEmdGPQbFY";
    private static final String POST_ACCOUNT = "http://localhost:8080/auth/signup";
    private static final String SING_IN = "http://localhost:8080/auth/signin";

    private static HttpResponse<String> getAuthResponse = null;
    private static HttpResponse<String> getItemsResponse = null;
    private static HttpResponse<String> postItemResponse = null;
    private static HttpResponse<String> postAccountResponse = null;
    private static HttpResponse<String> signInResponse = null;

    @BeforeAll
    public static void getConnections(){
        getAuthResponse = getRequest(GET_AUTH);
        getItemsResponse = getRequest(GET_ITEM);
        postItemResponse = postItemRequest(POST_ITEM);
        postAccountResponse = postAccountRequest(POST_ACCOUNT);
        signInResponse = singInRequest(SING_IN);
    }

    public static HttpResponse<String> getResponse(HttpRequest request) {
        HttpClient client = HttpClient.newHttpClient();
        HttpResponse<String> response = null;
        try {
            response = client.send(request, HttpResponse.BodyHandlers.ofString());
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        }
        return response;
    }

    public static HttpResponse<String> getRequest(String url) {
        HttpRequest request = HttpRequest.newBuilder().uri(URI.create(url))
                .header("Content-Type", "application/json")
                .build();
        return getResponse(request);
    }

    public static HttpResponse<String> postItemRequest(String url){
        HttpRequest request = HttpRequest.newBuilder().uri(URI.create(url))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString("""
                            {
                                "item":"tree"
                            }
                        """))
                .build();
        return getResponse(request);
    }

    public static HttpResponse<String> postAccountRequest(String url){
        HttpRequest request = HttpRequest.newBuilder().uri(URI.create(url))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString("""
                            {
                                "firstname" : "Mike",
                                "lastname" : "Smith",
                                "username" : "Smith123",
                                "password" : "bluecat123"
                            }
                        """))
                .build();
        return getResponse(request);
    }

    public static HttpResponse<String> singInRequest(String url){
        HttpRequest request = HttpRequest.newBuilder().uri(URI.create(url))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString("""
                            {
                                "username" : "Smith123",
                                "password" : "bluecat123"
                            }
                        """))
                .build();
        return getResponse(request);
    }

    @Test
    @DisplayName("Check if user authorized")
    public void checkIfAuth(){
        Assertions.assertEquals(200, getAuthResponse.statusCode());
    }

    @Test
    @DisplayName("Get list of items")
    public void getList(){
        Assertions.assertEquals(200, getItemsResponse.statusCode());
    }

    @Test
    @DisplayName("Add new item")
    public void addItem(){
        Assertions.assertEquals(200, postItemResponse.statusCode());
    }


    @Test
    @DisplayName("Log into account")
    public void logIn(){
        Assertions.assertEquals(200, signInResponse.statusCode());
    }





}
