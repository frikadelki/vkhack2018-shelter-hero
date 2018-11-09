#include "RoutingHandler.h"

using namespace hrp;
using namespace grpc;

int main()
{
    std::string server_address("0.0.0.0:12100");
    RoutingHandler service;

    ServerBuilder builder;
    builder.AddListeningPort(server_address, grpc::InsecureServerCredentials());
    builder.RegisterService(&service);
    std::unique_ptr<Server> server(builder.BuildAndStart());
    std::cout << "Routing server listening on " << server_address << std::endl;
    server->Wait();

    return 0;
}
