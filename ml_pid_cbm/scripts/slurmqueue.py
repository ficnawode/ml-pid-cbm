import curses
import subprocess
import time

def execute_process():
    # Modify this function to execute the desired process
    # For example, here we'll just run the "date" command
    process = subprocess.Popen(['squeue',' -u','tfic'], stdout=subprocess.PIPE, text=True)
    output, _ = process.communicate()
    return output.strip()

def main(stdscr):
    # Clear the screen and hide the cursor
    curses.curs_set(0)
    stdscr.clear()

    try:
        while True:
            # Get the output of the process
            result = execute_process()

            # Clear the screen before updating the content
            stdscr.clear()

            # Print the output of the process in the ncurses window
            stdscr.addstr(0, 0, "Output of the process:")
            stdscr.addstr(2, 0, result)

            # Refresh the screen to show the updated content
            stdscr.refresh()

            # Wait for one second before executing the process again
            time.sleep(1)
    except KeyboardInterrupt:
        # Handle Ctrl+C to gracefully exit the program
        pass

if __name__ == "__main__":
    curses.wrapper(main)

