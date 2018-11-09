#include "RecommendationsHandler.h"

namespace sh
{
    using namespace grpc;

    Status RecommendationsHandler::findRecommendations
    (
          ServerContext* context
        , const generated::Task* request
        , generated::Recommendations* response
    )
    {
        return Status::OK;
    }
}
