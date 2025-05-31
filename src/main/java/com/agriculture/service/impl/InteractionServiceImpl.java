package com.agriculture.service.impl;

import com.agriculture.dao.InteractionMapper;
import com.agriculture.model.po.Interaction;
import com.agriculture.service.InteractionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class InteractionServiceImpl implements InteractionService {
    @Autowired
    private InteractionMapper interactionMapper;
    @Override
    public void addLike(Integer postId, Integer userId) {
        try {
            Interaction interaction = new Interaction(null, postId, userId, Interaction.TYPE_LIKE, null);
            interactionMapper.insertInteraction(interaction);
        } catch ( Exception e){
            e.printStackTrace();
            throw new RuntimeException("点赞失败");
        }
    }

    @Override
    public void addCollection(Integer postId, Integer userId) {
        try {
            Interaction interaction = new Interaction(null, postId, userId, Interaction.TYPE_COLLECT, null);
            interactionMapper.insertInteraction(interaction);
        } catch ( Exception e){
            e.printStackTrace();
            throw new RuntimeException("收藏失败");
        }
    }

    @Override
    public void deleteLike(Integer postId, Integer userId) {
        try {
            interactionMapper.deleteInteractionByCondition(new Interaction(null, postId, userId, Interaction.TYPE_LIKE, null));

        } catch ( Exception e){
            e.printStackTrace();
            throw new RuntimeException("取消点赞失败");
        }
    }

    @Override
    public void deleteCollection(Integer postId, Integer userId) {
        try {
            interactionMapper.deleteInteractionByCondition(new Interaction(null, postId, userId, Interaction.TYPE_COLLECT, null));
        } catch ( Exception e){
            e.printStackTrace();
            throw new RuntimeException("取消收藏失败");
        }
    }


    @Override
    public int getLikeCount(Integer postId) {
        try {
            return interactionMapper.countInteractionByCondition(new Interaction(null, postId, null, Interaction.TYPE_LIKE, null));
        } catch ( Exception e){
            e.printStackTrace();
            throw new RuntimeException("获取点赞数失败");
        }
    }

    @Override
    public int getCollectionCount(Integer postId) {
        try {
            return interactionMapper.countInteractionByCondition(new Interaction(null, postId, null, Interaction.TYPE_COLLECT, null));
        }catch ( Exception e){
            e.printStackTrace();
            throw new RuntimeException("获取收藏数失败");
        }
    }

    @Override
    public void deletePostInteraction(Integer postId) {
        try {
             interactionMapper.deletePostInteraction(postId);
        } catch ( Exception e){
            e.printStackTrace();
            throw new RuntimeException("删除帖子相关互动失败");
        }
    }

    @Override
    public boolean isLiked(Integer postId, Integer userId) {
        try {
            return interactionMapper.existsInteraction(new Interaction(null, postId, userId, Interaction.TYPE_LIKE, null));
        } catch ( Exception e){
            e.printStackTrace();
            throw new RuntimeException("判断是否点赞失败");
        }
    }

    @Override
    public boolean isCollected(Integer postId, Integer userId) {
        try {
            return interactionMapper.existsInteraction(new Interaction(null, postId, userId, Interaction.TYPE_COLLECT, null));
        } catch ( Exception e) {
            e.printStackTrace();
            throw new RuntimeException("判断是否收藏失败");
        }
    }
}
