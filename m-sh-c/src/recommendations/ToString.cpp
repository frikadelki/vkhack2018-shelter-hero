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
}
