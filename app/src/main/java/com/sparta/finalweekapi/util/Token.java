package com.sparta.finalweekapi.util;

import javax.crypto.KeyGenerator;
import java.security.Key;
import java.security.NoSuchAlgorithmException;

import io.jsonwebtoken.JwtBuilder;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

public class Token {

    public static String generateToken(String username) throws NoSuchAlgorithmException {
        SignatureAlgorithm signatureAlgorithm = SignatureAlgorithm.HS256;
        KeyGenerator generator = KeyGenerator.getInstance("AES");
        generator.init(128);

        Key secretKey = generator.generateKey();

        JwtBuilder builder = Jwts.builder().setSubject(username).signWith(signatureAlgorithm, secretKey);

        return builder.compact();
    }
}
