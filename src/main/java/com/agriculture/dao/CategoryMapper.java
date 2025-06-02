package com.agriculture.dao;

import com.agriculture.model.po.Category;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CategoryMapper {
    int insertCategory(Category category);
    void batchInsertCategory(List<Category> categories);
    void deleteCategoryById(Integer id);
    void updateCategory(Category category);
    Category selectCategoryById(Integer id);
    List<Category> selectAllCategory();
    Category selectCategoryByName(String name);
    List<Category> searchCategoryByName(String name);

    List<Category> selectCategoryByCondition(Category category);
    int countCategory();
    boolean existsCategory(@Param(value = "name") String name,@Param(value = "id") int id);
    boolean existsCategoryByName(String name);
}
