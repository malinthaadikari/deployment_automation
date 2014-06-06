package org.wso2.ssh;


import com.jcraft.jsch.*;
import java.awt.*;
import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.*;

public class Exec{

    JTextField hostField;
    JTextField userNameField;
    JTextField passwordField;
    JPanel panel;


    public Exec() {
//        JPanel p = panel = new JPanel(new GridLayout(0,2));
//        hostField = new JTextField(20);
//        userNameField = new JTextField(20);
//        passwordField = new JPasswordField(20);
//        JButton testButton = new JButton("connect!");
//        testButton.addActionListener(new ActionListener() {
//            public void actionPerformed(ActionEvent ev) {
//                testConnectionButtonActionPerformed(ev);
//            }
//        });
//        p.add(new JLabel("host:"));
//        p.add(hostField);
//        p.add(new JLabel("user:"));
//        p.add(userNameField);
//        p.add(new JLabel("password:"));
//        p.add(passwordField);
//        p.add(testButton);
        try {
            JSch jsch = new JSch();

            String host = hostField.getText();
            String username = userNameField.getText();
            String password = passwordField.getText();

            Session session = jsch.getSession(username, host);
            session.setPassword(password);
            session.setConfig("StrictHostKeyChecking", "no");

            session.setTimeout(20000);
            System.out.println("Connecting to server...");
            session.connect();

            String command=JOptionPane.showInputDialog("Enter command, execed with sudo",
                    "printenv SUDO_USER");

            String sudo_pass=null;
            {
                JTextField passwordField=(JTextField)new JPasswordField(8);
                Object[] ob={passwordField};
                int result=
                        JOptionPane.showConfirmDialog(null,
                                ob,
                                "Enter password for sudo",
                                JOptionPane.OK_CANCEL_OPTION);
                if(result!=JOptionPane.OK_OPTION){
                    System.exit(-1);
                }
                sudo_pass=passwordField.getText();
            }

            Channel channel=session.openChannel("exec");
// man sudo
// -S The -S (stdin) option causes sudo to read the password from the
// standard input instead of the terminal device.
// -p The -p (prompt) option allows you to override the default
// password prompt and use a custom one.
            ((ChannelExec)channel).setCommand("sudo -S -p '' "+command);


            InputStream in=channel.getInputStream();
            OutputStream out=channel.getOutputStream();
            ((ChannelExec)channel).setErrStream(System.err);

            channel.connect();

            out.write((sudo_pass+"\n").getBytes());
            out.flush();

            byte[] tmp=new byte[1024];
            while(true){
                while(in.available()>0){
                    int i=in.read(tmp, 0, 1024);
                    if(i<0)break;
                    System.out.print(new String(tmp, 0, i));
                }
                if(channel.isClosed()){
                    System.out.println("exit-status: "+channel.getExitStatus());
                    break;
                }
                try{Thread.sleep(1000);}catch(Exception ee){}
            }





           // return session;
        }
        catch(Exception ex) {
            ex.printStackTrace();
         //   throw ex;
        }

    }

    public JPanel getPanel() {
        return panel;
    }

    private void testConnectionButtonActionPerformed(ActionEvent evt) {

        SwingWorker sw = new SwingWorker(){

            protected Object doInBackground() throws Exception {
                try {
                    JSch jsch = new JSch();

                    String host = hostField.getText();
                    String username = userNameField.getText();
                    String password = passwordField.getText();

                    Session session = jsch.getSession(username, host);
                    session.setPassword(password);
                    session.setConfig("StrictHostKeyChecking", "no");

                    session.setTimeout(20000);
                    System.out.println("Connecting to server...");
                    session.connect();

                    String command=JOptionPane.showInputDialog("Enter command, execed with sudo",
                            "printenv SUDO_USER");

                    String sudo_pass=null;
                    {
                        JTextField passwordField=(JTextField)new JPasswordField(8);
                        Object[] ob={passwordField};
                        int result=
                                JOptionPane.showConfirmDialog(null,
                                        ob,
                                        "Enter password for sudo",
                                        JOptionPane.OK_CANCEL_OPTION);
                        if(result!=JOptionPane.OK_OPTION){
                            System.exit(-1);
                        }
                        sudo_pass=passwordField.getText();
                    }

                    Channel channel=session.openChannel("exec");
// man sudo
// -S The -S (stdin) option causes sudo to read the password from the
// standard input instead of the terminal device.
// -p The -p (prompt) option allows you to override the default
// password prompt and use a custom one.
                    ((ChannelExec)channel).setCommand("sudo -S -p '' "+command);


                    InputStream in=channel.getInputStream();
                    OutputStream out=channel.getOutputStream();
                    ((ChannelExec)channel).setErrStream(System.err);

                    channel.connect();

                    out.write((sudo_pass+"\n").getBytes());
                    out.flush();

                    byte[] tmp=new byte[1024];
                    while(true){
                        while(in.available()>0){
                            int i=in.read(tmp, 0, 1024);
                            if(i<0)break;
                            System.out.print(new String(tmp, 0, i));
                        }
                        if(channel.isClosed()){
                            System.out.println("exit-status: "+channel.getExitStatus());
                            break;
                        }
                        try{Thread.sleep(1000);}catch(Exception ee){}
                    }





                    return session;
                }
                catch(Exception ex) {
                    ex.printStackTrace();
                    throw ex;
                }
            }

            public void done(){
                try {
                    System.out.println(get());
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
        };

        sw.execute();

    }


    public static void main(String[] egal) {
        EventQueue.invokeLater(new Runnable(){public void run() {
            Exec ex = new Exec();
            JFrame f = new JFrame("bla");
            f.setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);
            f.setContentPane(ex.getPanel());
            f.pack();
            f.setVisible(true);
        }});
    }
}
