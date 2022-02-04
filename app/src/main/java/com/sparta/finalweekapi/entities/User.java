package com.sparta.finalweekapi.entities;

import javax.persistence.*;

@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "userid", nullable = false)
    private Integer id;

    @Column(name = "firstname", nullable = false, length = 160)
    private String firstname;

    @Column(name = "lastname", nullable = false, length = 160)
    private String lastname;

    @Column(name = "username", nullable = false, length = 160)
    private String username;

    @Column(name = "password", nullable = false, length = 160)
    private String password;

    @Column(name = "token", nullable = false, length = 160)
    private String token;

    public User() {

    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getLastname() {
        return lastname;
    }

    public void setLastname(String lastname) {
        this.lastname = lastname;
    }

    public String getFirstname() {
        return firstname;
    }

    public void setFirstname(String firstname) {
        this.firstname = firstname;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public User(String firstname, String lastname, String username, String password, String token) {
        this.firstname = firstname;
        this.lastname = lastname;
        this.username = username;
        this.password = password;
        this.token = token;
    }
}