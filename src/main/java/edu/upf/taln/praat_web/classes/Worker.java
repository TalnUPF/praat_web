package edu.upf.taln.praat_web.classes;

/**
 * Thread extended class that is used to run a process for a limited time.
 *
 */
public class Worker extends Thread {
	private final Process process;
	public Integer exit;
	public Worker(Process process) {
		this.process = process;
	}
	public void run() {
		try { 
			exit = process.waitFor();
		} catch (InterruptedException ignore) {
			return;
		}
	}  
}
