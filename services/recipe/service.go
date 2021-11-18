package main

import (
	"context"
	pb "github.com/shawntabai/pando/proto/services/recipe"
)

func (s *PandomiumServer) GetRecipe(ctx context.Context, in *pb.GetRecipeRequest) (*pb.GetRecipeResponse, error) {
	return &pb.GetRecipeResponse{}, nil
}
