package com.agriculture.service;

public interface InteractionService {
    void addLike(Integer postId, Integer userId);
    void addCollection(Integer postId, Integer userId);
    void deleteLike(Integer postId, Integer userId);
    void deleteCollection(Integer postId, Integer userId);
    int getLikeCount(Integer postId);
    int getCollectionCount(Integer postId);
    void deletePostInteraction(Integer postId);
    boolean  isLiked(Integer postId, Integer userId);
    boolean  isCollected(Integer postId, Integer userId);
}
