package org.team8.coffeeproject.Respository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;
import org.team8.coffeeproject.Entity.User;
import jakarta.persistence.NoResultException;

@Repository
public class UserRepository {
    @PersistenceContext
    private EntityManager em;

    public User findByEmail(String email){
        try {
            return em.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class)
                    .setParameter("email", email)
                    .getSingleResult();
        } catch (NoResultException e) {
            // 결과가 없으면 null 반환
            return null;
        }
    }

    public void save(User user) {
        em.persist(user);
    }
}
