import React from "react";
import Tasks from "./Tasks";
import { Paper, TextField, Checkbox, Button } from "@material-ui/core";
import "./App.css";

class App extends Tasks {
    // Note: No state definition here! It inherits from Tasks.

    render() {
        const { tasks, currentTask } = this.state;
        
        return (
            <div className="App flex">
                <Paper elevation={3} className="container">
                    <div className="heading">TO-DO</div>
                    <form onSubmit={this.handleSubmit} className="flex" style={{ margin: "15px 0" }}>
                        <TextField
                            variant="outlined"
                            size="small"
                            style={{ width: "80%" }}
                            value={currentTask}
                            required={true}
                            onChange={this.handleChange}
                            placeholder="Add New TO-DO"
                        />
                        <Button style={{ height: "40px" }} color="primary" variant="outlined" type="submit">
                            Add task
                        </Button>
                    </form>
                    <div>
                        {tasks.map((task, index) => (
                            <Paper key={task._id || task.id || index} className="flex task_container">
                                <Checkbox
                                    checked={task.completed || false}
                                    onClick={() => this.handleUpdate(task._id || task.id)}
                                    color="primary"
                                />
                                <div className={task.completed ? "task line_through" : "task"}>
                                    {/* DEBUG: If 'task' property is missing, show raw JSON */}
                                    {task.task ? task.task : `Missing 'task' field: ${JSON.stringify(task)}`}
                                </div>
                                <Button onClick={() => this.handleDelete(task._id || task.id)} color="secondary">
                                    delete
                                </Button>
                            </Paper>
                        ))}
                    </div>
                </Paper>
            </div>
        );
    }
}

export default App;