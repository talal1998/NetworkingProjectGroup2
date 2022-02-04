package com.sparta.finalweekapi.repositories;

import com.sparta.finalweekapi.entities.Item;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ItemRepository extends JpaRepository<Item, Integer> {
}