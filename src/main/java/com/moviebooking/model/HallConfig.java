package com.moviebooking.model;

/**
 * Represents the seat layout configuration for a cinema hall.
 * Stores how many rows of each seat type exist and how many seats per row.
 */
public class HallConfig {
    private String hallName;
    private int seatsPerRow;
    private String standardRows; // Comma-separated row letters e.g. "A,B,C,D"
    private String premiumRows;  // e.g. "E,F"
    private String reclinerRows; // e.g. ""
    private String vipRows;      // e.g. "G"
    private String layoutMap;    // Advanced visual map string e.g. "S S _ S S|S S _ S S"

    public HallConfig() {}

    public HallConfig(String hallName, int seatsPerRow, String standardRows,
                      String premiumRows, String reclinerRows, String vipRows, String layoutMap) {
        this.hallName = hallName;
        this.seatsPerRow = seatsPerRow;
        this.standardRows = standardRows;
        this.premiumRows = premiumRows;
        this.reclinerRows = reclinerRows;
        this.vipRows = vipRows;
        this.layoutMap = layoutMap;
    }

    public String getHallName() { return hallName; }
    public void setHallName(String hallName) { this.hallName = hallName; }

    public int getSeatsPerRow() { return seatsPerRow; }
    public void setSeatsPerRow(int seatsPerRow) { this.seatsPerRow = seatsPerRow; }

    public String getStandardRows() { return standardRows; }
    public void setStandardRows(String standardRows) { this.standardRows = standardRows; }

    public String getPremiumRows() { return premiumRows; }
    public void setPremiumRows(String premiumRows) { this.premiumRows = premiumRows; }

    public String getReclinerRows() { return reclinerRows; }
    public void setReclinerRows(String reclinerRows) { this.reclinerRows = reclinerRows; }

    public String getVipRows() { return vipRows; }
    public void setVipRows(String vipRows) { this.vipRows = vipRows; }

    public String getLayoutMap() { return layoutMap; }
    public void setLayoutMap(String layoutMap) { this.layoutMap = layoutMap; }

    /** Returns total number of seats in this hall across all row types */
    public int getTotalSeats() {
        if (layoutMap != null && !layoutMap.trim().isEmpty()) {
            int count = 0;
            for (char c : layoutMap.toCharArray()) {
                if (c == 'S' || c == 'P' || c == 'R' || c == 'V') count++;
            }
            return count;
        }
        int count = 0;
        count += countRows(standardRows);
        count += countRows(premiumRows);
        count += countRows(reclinerRows);
        count += countRows(vipRows);
        return count * seatsPerRow;
    }

    private int countRows(String rows) {
        if (rows == null || rows.trim().isEmpty()) return 0;
        return rows.trim().split(",").length;
    }
}
