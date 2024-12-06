package org.team8.coffeeproject.Respository;

import jakarta.persistence.EntityManager;

import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;
import org.team8.coffeeproject.Entity.Product;

import java.util.List;
import java.util.Optional;

@Repository
public class ProductRepository {
    @PersistenceContext
    private EntityManager em;

    public Optional<Product> findById(Long productId){

        Optional<Product> product = Optional.ofNullable(em.createQuery("select p from Product p where p.id = :productId", Product.class)
                        .setParameter("productId", productId)
                        .getSingleResult());

        return product;
    };

    public List<Product> findAll() {

        List<Product> productList = em.createQuery("select p from Product p", Product.class)
                                      .getResultList();

        return productList;
    }
}
