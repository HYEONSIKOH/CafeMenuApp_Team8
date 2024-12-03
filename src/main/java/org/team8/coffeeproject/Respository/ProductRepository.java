package org.team8.coffeeproject.Respository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.team8.coffeeproject.Entity.Product;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    Product findByProductNm(String productNm);
}
