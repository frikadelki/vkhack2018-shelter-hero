#include "RecommendationsHandler.h"

#include "RecommendationsSearcher.h"
#include "ToString.h"

#include <exception>
#include <iostream>

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
        assert(nullptr != request);
        assert(nullptr != response);

        std::cout << "[RecommendationsHandler::findRecommendations] Task: " << toString(*request) << std::endl;

        try
        {
            response->CopyFrom(::sh::findRecommendations(*request));
            std::cout << "[RecommendationsHandler::findRecommendations] Result: " << toString(*response) << std::endl;

            return Status::OK;
        }
        catch (const std::exception& ex)
        {
            std::cerr << "std::exception: " << ex.what() << std::endl;
        }
        catch (...)
        {
            std::cerr << "Strange error." << std::endl;
        }

        return Status(INTERNAL, string(":("));
    }
}
