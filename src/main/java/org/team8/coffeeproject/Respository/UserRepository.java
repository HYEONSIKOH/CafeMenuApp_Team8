package org.team8.coffeeproject.Respository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.team8.coffeeproject.Entity.User;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    // SELECT * FROM user WHERE email = ?
    User findByEmail(String email);
}