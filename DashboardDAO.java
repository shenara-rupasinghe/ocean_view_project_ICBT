package com.oceanview.dao;

import com.oceanview.util.DBConnection;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;

/**
 * Logic Tier: Handles complex dashboard data retrieval using Stored Procedures.
 * Design Pattern: DAO and Singleton concepts.
 */
public class DashboardDAO {

    public Map<String, Object> getComprehensiveStats() {
        Map<String, Object> data = new HashMap<>();

        // Calling the Advanced DB Stored Procedure
        String sql = "{CALL GetDashboardSummary()}";

        try (Connection conn = DBConnection.getInstance().getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {

            ResultSet rs = cs.executeQuery();
            if (rs.next()) {
                data.put("occupied", rs.getInt("occupied_count"));
                data.put("available", rs.getInt("available_count"));
                data.put("arrivals", rs.getInt("arrivals_today"));
                data.put("revenue", rs.getDouble("total_revenue"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return data;
    }
    public double calculateOccupancyRate(int occupied, int available) {
        int total = occupied + available;

        // Defensive programming: Handle potential division by zero error
        if (total <= 0) {
            return 0.0;
        }

        // Perform the calculation with explicit double casting for precision
        return ((double) occupied / total) * 100;
    }
}

//update