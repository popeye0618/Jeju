package com.jeju.jeju.infrastructure.tourapi;

public class TourApiBarrierFreeDto {

    private String contentid;
    private String wheelchair;
    private String elevator;
    private String restroom;
    private String route;
    private String parking;

    public TourApiBarrierFreeDto() {}

    public String getContentid()                    { return contentid; }
    public void setContentid(String contentid)      { this.contentid = contentid; }

    public String getWheelchair()                   { return wheelchair; }
    public void setWheelchair(String wheelchair)    { this.wheelchair = wheelchair; }

    public String getElevator()                     { return elevator; }
    public void setElevator(String elevator)        { this.elevator = elevator; }

    public String getRestroom()                     { return restroom; }
    public void setRestroom(String restroom)        { this.restroom = restroom; }

    public String getRoute()                        { return route; }
    public void setRoute(String route)              { this.route = route; }

    public String getParking()                      { return parking; }
    public void setParking(String parking)          { this.parking = parking; }
}
