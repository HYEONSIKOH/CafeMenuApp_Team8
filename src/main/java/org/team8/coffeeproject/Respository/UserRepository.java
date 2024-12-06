package org.team8.coffeeproject.Respository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;
import org.team8.coffeeproject.Entity.User;

@Repository
public class UserRepository {
    @PersistenceContext
    private EntityManager em;

    public User findByEmail(String email){
        User user = em.createQuery( "SELECT u FROM User u WHERE u.email = :email",User.class)
                .setParameter("email", email)
                .getSingleResult();

        return user;
    }

    public void save(User user) {
        em.persist(user);
    }
}
