//optional: category, tage, savedjob
package model;

import java.util.Date;

/**
 *
 * @author qp
 */
public class Notification {

    private int notificationID;
    private int userID;
    private String type;
    private String title;
    private String content;
    private boolean isRead;
    private Date createdAt;
}
