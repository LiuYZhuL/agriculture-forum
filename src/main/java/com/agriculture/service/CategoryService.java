package com.agriculture.service;

import com.agriculture.model.po.Category;
import com.github.pagehelper.PageInfo;
import java.util.Map;

public interface CategoryService {
    void addCategory(Category category);
    void updateCategory(Category category);
    void deleteCategory(Integer categoryId);
    Category getCategoryById(Integer categoryId);
    PageInfo<Category> listCategories(int pageNum, int pageSize);
    PageInfo<Category> searchCategories(String searchText, int pageNum, int pageSize);
    Map<Integer, String> listCategoriesForMap();

}
