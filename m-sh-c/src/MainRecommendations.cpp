#include "RecommendationsHandler.h"

#include <iostream>

using namespace sh;
using namespace grpc;

int main()
{
    std::string server_address("0.0.0.0:12100");
    RecommendationsHandler service;

    ServerBuilder builder;
    builder.AddListeningPort(server_address, InsecureServerCredentials());
    builder.RegisterService(&service);
    std::unique_ptr<Server> server(builder.BuildAndStart());
    std::cout << "Recommendations server listening on " << server_address << std::endl;
    server->Wait();

    return 0;
}
