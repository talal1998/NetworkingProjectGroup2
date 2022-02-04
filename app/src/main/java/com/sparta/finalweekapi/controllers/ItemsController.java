package com.sparta.finalweekapi.controllers;

import com.sparta.finalweekapi.entities.Item;
import com.sparta.finalweekapi.entities.User;
import com.sparta.finalweekapi.repositories.ItemRepository;
import com.sparta.finalweekapi.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping(value = "/items")
public class ItemsController {

    @Autowired
    private ItemRepository itemRepository;

    @Autowired
    private UserRepository userRepository;

    @GetMapping(value = "all")
    public List<Item> getAllItems(@RequestParam String token){
        Optional<User> user = userRepository.findUserByToken(token);

        return user.map(value -> itemRepository
                .findAll()
                .stream()
                .filter(item -> item.getUserId().getId() == value.getId())
                .toList()).orElse(null);
    }

    @PostMapping(value = "add")
    public ResponseEntity<String> addItem(@RequestBody Item item, @RequestParam String token){
        Optional<User> user = userRepository.findUserByToken(token);
        if(user.isPresent()){
            itemRepository.save(new Item(user.get(), item.getItem()));
            return new ResponseEntity<>("Item added for " + user.get().getUsername(), HttpStatus.OK);
        } else {
            return new ResponseEntity<>("User not found, Please register first!", HttpStatus.NOT_FOUND);
        }
    }

    @DeleteMapping(value = "delete")
    public Map<String,Boolean> deleteItem(@RequestParam Integer id, @RequestParam String token){
        Optional<User> user = userRepository.findUserByToken(token);
        Map<String, Boolean> response = new HashMap<>();
        if(user.isPresent()){
            Optional<Item> item = itemRepository.findById(id);
            if(item.isPresent()){
                itemRepository.delete(item.get());
                response.put("Deleted", true);
            } else {
                response.put("Item exists", false);
            }
        } else {
            response.put("User exists", false);
        }
        return response;
    }




}
