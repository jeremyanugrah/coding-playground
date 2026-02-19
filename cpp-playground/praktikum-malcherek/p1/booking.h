#ifndef BOOKING_H
#define BOOKING_H
#include "travelagency.h"
#include <string>

class Booking {
    protected:
    std::string id;
    double price;
    std::string fromDate;
    std::string toDate;
    public:
    Booking();
    std::string showDetails();

#endif
