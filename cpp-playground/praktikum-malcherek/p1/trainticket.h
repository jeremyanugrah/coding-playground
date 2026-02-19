#ifndef TRAINTICKET_H
#define TRAINTICKET_H

class TrainTicket {
    std::string fromDestination;
    std::string toDestination;
    vector<string> connectingStations;
    std::string departureTime;
    std::string arrival;

    public:
    std::string showDetails();


#endif
