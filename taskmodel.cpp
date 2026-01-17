#include "TaskModel.h"

TaskModel::TaskModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

int TaskModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return static_cast<int>(m_tasks.size());
}

QVariant TaskModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_tasks.size())
        return QVariant();

    const Task &item = m_tasks[index.row()];

    if (role == TaskNameRole) {
        return item.name;
    } else if (role == TaskCompletedRole) {
        return item.isCompleted;
    }
    return QVariant();
}

QHash<int, QByteArray> TaskModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TaskNameRole] = "task";
    roles[TaskCompletedRole] = "completed";
    return roles;
}

void TaskModel::addTask(const QString &taskName)
{
    beginInsertRows(QModelIndex(), m_tasks.size(), m_tasks.size());
    m_tasks.push_back({taskName, false});
    endInsertRows();
}

void TaskModel::removeTask(int index)
{
    if (index < 0 || index >= m_tasks.size())
        return;

    beginRemoveRows(QModelIndex(), index, index);
    m_tasks.erase(m_tasks.begin() + index);
    endRemoveRows();
}

void TaskModel::toggleTask(int index)
{
    if (index < 0 || index >= m_tasks.size())
        return;

    m_tasks[index].isCompleted = !m_tasks[index].isCompleted;

    QModelIndex indexObj = createIndex(index, 0);

    emit dataChanged(indexObj, indexObj, {TaskCompletedRole});
}
