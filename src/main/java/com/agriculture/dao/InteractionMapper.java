package com.agriculture.dao;

import com.agriculture.model.po.Interaction;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
@Mapper
public interface InteractionMapper {
    int insertInteraction(Interaction interaction);
    void batchInsertInteraction(List<Interaction> interactions);
    int deleteInteractionById(int id);
    void deleteInteractionByCondition(Interaction interaction);
    void updateInteraction(Interaction interaction);
    Interaction selectInteractionById(int id);
    List<Interaction> selectAllInteraction();
    List<Interaction> selectInteractionByUserId(int userId);
    List<Interaction> selectInteractionByPostId(int postId);
    List<Interaction> selectInteractionByType(int type);
    List<Interaction> selectInteractionByCondition(Interaction interaction);
    boolean existsInteraction(Interaction interaction);
    int countInteraction();
    int countInteractionByCondition(Interaction interaction);

}
