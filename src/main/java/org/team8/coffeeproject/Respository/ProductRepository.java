package org.team8.coffeeproject.Respository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.team8.coffeeproject.Entity.Product;

import java.util.List;
import java.util.Optional;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    Product findByProductNm(String productNm);
    Optional<Product> findById(Long productId);
    List<Product> findAll();

}
