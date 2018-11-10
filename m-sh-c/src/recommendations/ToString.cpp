#include "ToString.h"

#include "google/protobuf/util/json_util.h"

namespace sh
{
    std::string toString(const Trip& trip)
    {
        using namespace google::protobuf::util;

        std::string result;

        MessageToJsonString(trip, &result);

        return result;
    }
}
