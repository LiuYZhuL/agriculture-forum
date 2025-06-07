package com.agriculture.service.impl;

import com.agriculture.dao.CategoryMapper;
import com.agriculture.model.po.Category;
import com.agriculture.service.CategoryService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class CategoryServiceImpl implements CategoryService {
    @Autowired
    private CategoryMapper categoryMapper;
    @Override
    public void addCategory(Category category) {
        if (category == null) {
            throw new RuntimeException("参数错误");
        }
        if (category.getName() == null || category.getName().isEmpty()) {
            throw new RuntimeException("分类名称不能为空");
        }
        if (categoryMapper.existsCategoryByName(category.getName())) {
            throw new RuntimeException("该分类已存在");
        }
        try {
            categoryMapper.insertCategory(category);
        } catch (Exception e){
            throw new RuntimeException("添加失败");
        }
    }

    @Override
    public void updateCategory(Category category) {
        if (category == null || category.getId() == null) {
            throw new RuntimeException("参数错误");
        }
        if(categoryMapper.selectCategoryById(category.getId()) == null){
            throw new RuntimeException("分类不存在");
        }
        if (category.getName() == null || category.getName().isEmpty()) {
            throw new RuntimeException("分类名称不能为空");
        }
        if (categoryMapper.existsCategory(category.getName(), category.getId())) {
            throw new RuntimeException("该分类已存在");
        }
        try {
            categoryMapper.updateCategory(category);
        } catch (Exception e){
            throw new RuntimeException("修改失败");
        }
    }

    @Override
    public void deleteCategory(Integer categoryId) {
        if (categoryId < 0){
            throw new RuntimeException("参数错误");
        }
        try {
            // 删除分类前将该分类下的所有帖子置为未分类

            // 删除分类
            categoryMapper.deleteCategoryById(categoryId);
        } catch (Exception e){
            throw new RuntimeException("删除失败");
        }
    }

    @Override
    public Category getCategoryById(Integer categoryId) {
        if(categoryId < 0){
            throw new RuntimeException("参数错误");
        }
        return categoryMapper.selectCategoryById(categoryId);
    }

    @Override
    public PageInfo<Category> listCategories(int pageNum, int pageSize) {
        try {
            PageHelper.startPage(pageNum, pageSize);
            List<Category> categories = categoryMapper.selectAllCategory();
            return new PageInfo<>(categories, pageSize);
        } catch (Exception e) {
            // 捕获异常并记录日志
            e.printStackTrace();
            throw new RuntimeException("获取分类列表失败：" + e.getMessage());
        }
    }

    @Override
    public PageInfo<Category> searchCategories(String searchText, int pageNum, int pageSize) {
        try {
            PageHelper.startPage(pageNum, pageSize);
            // 添加空值判断
            if(searchText == null || searchText.trim().isEmpty()) {
                return new PageInfo<>(categoryMapper.selectAllCategory(), pageSize);
            }
            List<Category> categories = categoryMapper.searchCategoryByName(searchText.trim());
            return new PageInfo<>(categories, pageSize);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("搜索分类失败：" + e.getMessage());
        }
    }

    @Override
    public Map<Integer, String> listCategoriesForMap() {
        try {
            List<Category> categories = categoryMapper.selectAllCategory();
            Map<Integer, String> categoriesMap = new HashMap<>();
            for (Category category : categories) {
                categoriesMap.put(category.getId(), category.getName());
            }
            return categoriesMap;
        } catch (Exception e){
            throw new RuntimeException("获取分类列表失败");
        }
    }

    @Override
    public List<Category> listCategories() {
        try {
            List<Category> categories = categoryMapper.selectAllCategory();
            return categories;
        } catch (Exception e){
            throw new RuntimeException("获取分类列表失败");
        }
    }
}
