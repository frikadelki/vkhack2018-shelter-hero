#pragma once

#include "Recommendations.grpc.pb.h"

#include "HelperGrpc.h"

namespace sh
{
    class RecommendationsHandler final : public generated::RecommendationsSearcher::Service
    {
        grpc::Status findRecommendations
        (
              grpc::ServerContext* context
            , const generated::Task* request
            , generated::Recommendations* response
        ) override;
    };
}
