package edu.upf.taln.praat_web.utils;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeoutException;

import edu.upf.taln.praat_web.classes.Worker;

public class Utils {

	public static List<File> getFilesInFolder(File folder){
		List<File> files = new ArrayList<File>();
		if (folder.isDirectory()) {
			for (final File fileEntry : folder.listFiles()) {
		        if (!fileEntry.isDirectory()) {
		            files.add(fileEntry);
		        }
		    }
		}
		return files;
	}
	
	/**
	 * Function that deletes a folder and its content.
	 * @param folderPath
	 */
	public static void deleteFolderAndContent(String folderPath){
		File index = new File(folderPath);
		String[]entries = index.list();
		for(String s: entries){
		    File currentFile = new File(index.getPath(),s);
		    currentFile.delete();
		}
		index.delete();
	}
	
	/**
	 * Runs a command line and returns its prompt message.
	 * @param command List of command options.
	 * @param timeout Time to run the command before it is stopped.
	 * @return
	 * @throws Exception
	 */
	public static String executeCommand(List<String> command, long timeout) throws Exception {
		StringBuffer output = new StringBuffer();
		
		Process process = Runtime.getRuntime().exec(command.toArray(new String[command.size()]));
		Worker worker = new Worker(process);
		worker.start();
		try {
			worker.join(timeout);
			if (worker.exit != null){
				BufferedReader errReader = new BufferedReader(new InputStreamReader(process.getErrorStream()));
		    	BufferedReader inputReader = new BufferedReader(new InputStreamReader(process.getInputStream()));
				if (worker.exit > 0) {
                    String line = "";
                    while ((line = errReader.readLine()) != null) {
                        output.append(line + "\n");
                    }
                    throw new Exception(output.toString());
                } else {
                    String line = "";
                    while ((line = inputReader.readLine()) != null) {
                        output.append(line + "\n");
                    }
                    return output.toString();
                }
			}else{
				throw new TimeoutException("Script failed due to timeout.");
			}
		} catch(InterruptedException ex) {
			worker.interrupt();
			Thread.currentThread().interrupt();
			throw ex;
		} finally {
			process.destroy();
		}
	}
	
	/**
	 * Save uploaded file to a defined location on the server
	 * @param uploadedInputStream
	 * @param serverLocation
	 */
	public static void saveFile(InputStream uploadedInputStream,
			String serverLocation) {
		try {
			OutputStream outpuStream = new FileOutputStream(new File(serverLocation));
			int read = 0;
			byte[] bytes = new byte[1024];

			outpuStream = new FileOutputStream(new File(serverLocation));
			while ((read = uploadedInputStream.read(bytes)) != -1) {
				outpuStream.write(bytes, 0, read);
			}
			outpuStream.flush();
			outpuStream.close();
		} catch (IOException e) {
			e.printStackTrace();
		}

	}
	
}
