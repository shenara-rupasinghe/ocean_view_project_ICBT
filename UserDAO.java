package com.oceanview.dao;

import com.oceanview.util.DBConnection;
import java.sql.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserDAO {

    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    // 1. Authenticate User (Login)
    public Map<String, String> authenticateUser(String username, String password) {
        Map<String, String> userData = null;
        String sql = "SELECT full_name, role FROM users WHERE username = ? AND password = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    userData = new HashMap<>();
                    userData.put("fullName", rs.getString("full_name"));
                    userData.put("role", rs.getString("role"));
                }
            }
        } catch (SQLException e) { LOGGER.log(Level.SEVERE, "Auth error", e); }
        return userData;
    }

    // 2. Register New User (Admin or Staff)
    public boolean registerUser(String name, String user, String pass, String role) {
        String sql = "INSERT INTO users (full_name, username, password, role) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, user);
            ps.setString(3, pass);
            ps.setString(4, role);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Registration error", e);
            return false;
        }
    }

    public boolean updateUserDetails(String fullName, String email, String phone, String username) {
        String sql = "UPDATE users SET full_name = ?, email = ?, contact = ? WHERE username = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, username);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }

    // 4. Fetch All Users
    public List<Map<String, String>> getAllUsers() {
        List<Map<String, String>> users = new ArrayList<>();
        String sql = "SELECT id, full_name, username, role FROM users ORDER BY id DESC";
        try (Connection conn = DBConnection.getInstance().getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Map<String, String> u = new HashMap<>();
                u.put("id", rs.getString("id"));
                u.put("fullName", rs.getString("full_name"));
                u.put("username", rs.getString("username"));
                u.put("role", rs.getString("role"));
                users.add(u);
            }
        } catch (SQLException e) { LOGGER.log(Level.SEVERE, "Error fetching users", e); }
        return users;
    }

    // 5. Delete User
    public boolean deleteUser(String id) {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, Integer.parseInt(id));
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Delete error", e);
            return false;
        }
    }

    // 6. Update Staff Role and Name
    public boolean updateStaff(String id, String fullName, String role) {
        String sql = "UPDATE users SET full_name = ?, role = ? WHERE id = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullName);
            ps.setString(2, role);
            ps.setInt(3, Integer.parseInt(id));
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Update error", e);
            return false;
        }
    }
    /**
     * TDD Implementation: Phase 3 (REFACTOR)
     * Advanced validation using Regex to ensure password complexity.
     */
    public boolean isPasswordStrong(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }
        // Refactoring: Check for at least one digit and one special character
        return password.matches(".*[0-9].*") && password.matches(".*[!@#$%^&*()].*");
    }
}
