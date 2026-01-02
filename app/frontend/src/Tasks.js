import { Component } from "react";
import {
    addTask,
    getTasks,
    updateTask,
    deleteTask,
} from "./services/taskServices";

class Tasks extends Component {
    // Only define state here in the parent
    state = { tasks: [], currentTask: "" };

    async componentDidMount() {
        try {
            const { data } = await getTasks();
            // Ensure we always have an array
            this.setState({ tasks: Array.isArray(data) ? data : [] });
        } catch (error) {
            console.error("Fetch error:", error);
            this.setState({ tasks: [] });
        }
    }

    handleChange = ({ currentTarget: input }) => {
        this.setState({ currentTask: input.value });
    };

    handleSubmit = async (e) => {
        e.preventDefault();
        try {
            const { data } = await addTask({ task: this.state.currentTask });
            // Immutable update: spread existing tasks and add the new one
            this.setState({ 
                tasks: [...this.state.tasks, data], 
                currentTask: "" 
            });
        } catch (error) {
            console.error("Add error:", error);
        }
    };

    handleUpdate = async (taskId) => {
        const originalTasks = [...this.state.tasks];
        try {
            const tasks = [...originalTasks];
            const index = tasks.findIndex((t) => (t._id === taskId || t.id === taskId));
            if (index === -1) return;

            tasks[index] = { ...tasks[index], completed: !tasks[index].completed };
            this.setState({ tasks });
            
            await updateTask(taskId, { completed: tasks[index].completed });
        } catch (error) {
            this.setState({ tasks: originalTasks });
            console.error("Update error:", error);
        }
    };

    handleDelete = async (taskId) => {
        const originalTasks = [...this.state.tasks];
        try {
            const tasks = originalTasks.filter((t) => (t._id !== taskId && t.id !== taskId));
            this.setState({ tasks });
            await deleteTask(taskId);
        } catch (error) {
            this.setState({ tasks: originalTasks });
            console.error("Delete error:", error);
        }
    };
}

export default Tasks;