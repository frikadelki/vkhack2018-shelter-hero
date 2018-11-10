#include "ToString.h"

#include "google/protobuf/util/json_util.h"

namespace sh
{
    std::string toString(const Trip& trip)
    {
        std::string result;
        google::protobuf::util::MessageToJsonString(trip, &result);
        return result;
    }

    std::string toString(const Task& task)
    {
        std::string result;
        google::protobuf::util::MessageToJsonString(task, &result);
        return result;
    }

    std::string toString(const Recommendations& recommendations)
    {
        std::string result;
        google::protobuf::util::MessageToJsonString(recommendations, &result);
        return result;
    }
}
