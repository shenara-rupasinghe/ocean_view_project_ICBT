package com.oceanview.dao;

import com.oceanview.util.DBConnection;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class StaffDAO {

    private static final Logger LOGGER = Logger.getLogger(StaffDAO.class.getName());


    public boolean registerStaff(String name, String username, String role, String password) {
        String sql = "INSERT INTO users (full_name, username, role, password) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setString(2, username);
            ps.setString(3, role);
            ps.setString(4, password);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error registering staff member: " + username, e);
            return false;
        }
    }
    /**
     * TDD Implementation: Phase 3 (REFACTOR)
     * Optimizing the bonus logic with defensive checks for salary parameters.
     */
    public double calculateBonus(double salary, double bonusPercent) {
        // Refactoring: Validating inputs for business logic integrity
        if (salary <= 0 || bonusPercent < 0 || bonusPercent > 100) {
            return 0.0;
        }
        return salary * (bonusPercent / 100);
    }
}