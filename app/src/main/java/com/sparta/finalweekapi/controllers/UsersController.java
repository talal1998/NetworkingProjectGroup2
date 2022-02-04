package com.sparta.finalweekapi.controllers;

import com.sparta.finalweekapi.entities.LoginForm;
import com.sparta.finalweekapi.entities.User;
import com.sparta.finalweekapi.repositories.UserRepository;
import com.sparta.finalweekapi.util.Token;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.web.bind.annotation.*;

import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping(value= "/auth")
public class UsersController {

    @Autowired
    private UserRepository userRepository;

    @GetMapping(value = "test")
    public String test(@RequestParam String token){
        Optional<User> user = userRepository.findUserByToken(token);
        if(user.isPresent()){
            return "Authorized";
        } else {
            return "Unauthorized";
        }
    }

    @PostMapping(value = "signin")
    public ResponseEntity<String> login(@RequestBody LoginForm loginForm){

        Optional<User> user = userRepository.findUserByUsername(loginForm.getUsername());

        if(user.isPresent()){
            if(BCrypt.checkpw(loginForm.getPassword(),user.get().getPassword())){
                return new ResponseEntity<>("Session Token: " + user.get().getToken(), HttpStatus.OK);
            }
            else{
                return new ResponseEntity<>("Invalid credentials", HttpStatus.NOT_FOUND);
            }
        }
        else{
            return new ResponseEntity<>("User not found", HttpStatus.NOT_FOUND);
        }
    }

    @PostMapping(value = "signup")
    public ResponseEntity<String> createUser(@RequestBody User user) throws NoSuchAlgorithmException {
        boolean userExists = userRepository.findUserByUsername(user.getUsername()).isPresent();

        if(!userExists){
            if(user.getUsername().length() < 7 ){
                return new ResponseEntity<>("Username too short", HttpStatus.BAD_REQUEST);
            }
            userRepository.save(new User(user.getFirstname(), user.getLastname(), user.getUsername(), BCrypt.hashpw(user.getPassword(), BCrypt.gensalt(10)), Token.generateToken(user.getUsername())));
            return new ResponseEntity<>("User added successfully ", HttpStatus.OK);
        } else {
            return new ResponseEntity<>("Error : Username already exists", HttpStatus.BAD_REQUEST);
        }
    }


    @DeleteMapping(value = "delete")
    public Map<String, Boolean> deleteAccount(@RequestParam String username, @RequestParam String token){
        Optional<User> user = userRepository.findUserByToken(token);

        Map<String, Boolean> response = new HashMap<>();
        if(user.isPresent()){
            userRepository.delete(user.get());
            response.put("Deleted", true);
        } else {
            response.put("Deleted", false);
        }
        return response;
    }
}
